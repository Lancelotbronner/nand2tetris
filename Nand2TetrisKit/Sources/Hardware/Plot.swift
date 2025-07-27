////
////  Plot.swift
////  Nand2TetrisKit
////
////  Created by Christophe Bronner on 2025-01-12.
////
//
//pub struct Plot {
//	blocks: HashMap<BlockID, Block>,
//	connections: HashMap<ConnectionID, Connection>,
//
//	states: Vec<PlotState>,
//
//	#[serde(skip)]
//	selection: Selection,
//
//	#[serde(skip)]
//	to_update: HashSet<BlockID>,
//}
//
//impl Identifiable for Plot {
//	type ID = PlotDescriptor;
//}
//
//impl Plot {
//	pub fn new() -> Self {
//		Self {
//			blocks: HashMap::new(),
//			connections: HashMap::new(),
//			states: vec![PlotState::default()],
//			selection: Selection::None,
//			to_update: HashSet::new(),
//		}
//	}
//
//	pub fn push_state(&mut self) {
//		let state = self.into();
//		self.states.push(state);
//	}
//
//	pub fn pop_state(&mut self) {
//		if let Some(state) = self.states.pop() {
//			state.apply(self);
//		} else {
//			error!("Plot::pop_state() failed: stack is empty.")
//		}
//	}
//
//	pub fn blocks(&self) -> &HashMap<BlockID, Block> {
//		&self.blocks
//	}
//
//	pub fn blocks_mut(&mut self) -> &mut HashMap<BlockID, Block> {
//		&mut self.blocks
//	}
//
//	pub fn add_block(&mut self, block: Block) {
//		self.to_update.insert(block.id());
//		self.blocks.insert(block.id(), block);
//	}
//
//	pub fn get_block(&self, id: BlockID) -> Option<&Block> {
//		self.blocks.get(&id)
//	}
//
//	pub fn get_block_mut(&mut self, id: BlockID) -> Option<&mut Block> {
//		self.blocks.get_mut(&id)
//	}
//
//	pub fn get_waypoint_at(&self, position: Vector2<i32>) -> Option<SegmentID> {
//		for connection in self.connections.values() {
//			if let Some(waypoint) = connection.waypoint_at(position) {
//				return Some(waypoint);
//			}
//		}
//		None
//	}
//
//	pub fn get_block_at(&self, position: Vector2<i32>) -> Option<BlockID> {
//		for (i, block) in self.blocks.iter() {
//			if block.touches(position) {
//				return Some(*i);
//			}
//		}
//
//		None
//	}
//
//	pub fn connections(&self) -> &HashMap<ConnectionID, Connection> {
//		&self.connections
//	}
//
//	pub fn connections_mut(&mut self) -> &mut HashMap<ConnectionID, Connection> {
//		&mut self.connections
//	}
//
//	pub fn get_connection(&self, id: &ConnectionID) -> Option<&Connection> {
//		self.connections.get(id)
//	}
//
//	pub fn get_connection_mut(&mut self, id: &ConnectionID) -> Option<&mut Connection> {
//		self.connections.get_mut(id)
//	}
//
//	fn patch_destinations(&mut self, destinations: Vec<Port>, connection_id: ConnectionID) {
//		for destination in destinations {
//			let block = self
//				.blocks
//				.get_mut(&destination.block_id())
//				.expect("faulty destination block");
//			block.set_connection(destination.into(), Some(connection_id));
//		}
//	}
//
//	fn add_to_existing_connection(&mut self, existing: ConnectionID, connection: &Connection) {
//		if let Some(existing) = self.connections.get_mut(&existing) {
//			for segment in connection.segments().values() {
//				existing.add_segment(segment.clone());
//			}
//			let destinations = existing.destinations();
//			let id = existing.id();
//			self.patch_destinations(destinations, id);
//		}
//	}
//
//	pub unsafe fn add_connection_unsafe(&mut self, connection: Connection) {
//		self.to_update.insert(connection.origin().block_id());
//		self.connections.insert(connection.id(), connection);
//	}
//
//	pub fn add_connection(&mut self, connection: Connection) {
//		let origin = self
//			.blocks
//			.get_mut(&connection.origin().block_id())
//			.expect("faulty origin block");
//
//		if let Some(existing) = origin.connection(connection.origin().into()) {
//			self.add_to_existing_connection(existing, &connection);
//			return;
//		}
//
//		origin.set_connection(connection.origin().into(), Some(connection.id()));
//
//		self.patch_destinations(connection.destinations(), connection.id());
//		self.to_update.insert(connection.origin().block_id());
//		self.connections.insert(connection.id(), connection);
//	}
//
//	pub fn remove_connection(&mut self, id: ConnectionID) -> Option<Connection> {
//		if let Some(c) = self.connections.get(&id) {
//			let mut connection = c.clone();
//			let mut refactor = |port: Port| {
//				if let Some(block) = self.get_block_mut(port.block_id()) {
//					block.set_connection(port.into(), None);
//				}
//				self.to_update.insert(port.block_id());
//			};
//
//			refactor(connection.origin());
//
//			for destination in connection.destinations() {
//				refactor(destination);
//			}
//
//			self.connections.remove(&id);
//			connection.set_active(false);
//
//			return Some(connection);
//		}
//		None
//	}
//
//	pub fn delete_block(&mut self, id: BlockID) -> Vec<Connection> {
//		let mut deleted_connections = vec![];
//		let mut unique = false;
//		if let Some(block) = self.blocks.get(&id) {
//			unique = block.unique();
//			deleted_connections = block
//				.connected_to()
//				.iter()
//				.filter_map(|id| self.remove_connection(*id))
//				.collect();
//		}
//
//		if !unique {
//			self.blocks.remove(&id);
//		}
//
//		deleted_connections
//	}
//
//	pub fn add_block_to_update(&mut self, block: BlockID) {
//		self.to_update.insert(block);
//	}
//
//	pub fn to_update(&self) -> &HashSet<BlockID> {
//		&self.to_update
//	}
//
//	pub fn to_update_mut(&mut self) -> &mut HashSet<BlockID> {
//		&mut self.to_update
//	}
//
//	pub fn update_all_blocks(&mut self) {
//		for block_id in self.blocks.keys().copied() {
//			self.to_update.insert(block_id);
//		}
//	}
//
//	const RECURSION_CAP: u8 = 100;
//
//	pub fn simulate(
//		&mut self,
//		project: &mut Project,
//		call_stack: &mut HashSet<String>,
//	) -> SimResult<bool> {
//		let mut updated = HashMap::new();
//		let mut queued = HashSet::new();
//		let mut changes = false;
//
//		while !self.to_update.is_empty() {
//			let to_update = std::mem::take(&mut self.to_update);
//			changes = true;
//
//			for block_id in to_update.iter() {
//				if updated.contains_key(block_id) {
//					let occurrences = updated.get_mut(block_id).unwrap();
//					if *occurrences >= Self::RECURSION_CAP {
//						queued.insert(*block_id);
//						continue;
//					}
//					*occurrences += 1;
//				}
//
//				if let Some(block) = self.blocks.get_mut(block_id) {
//					block.simulate(
//						&mut self.connections,
//						&mut self.to_update,
//						&mut queued,
//						project,
//						call_stack,
//					)?;
//
//					if !updated.contains_key(block_id) {
//						updated.insert(*block_id, 0);
//					}
//				}
//			}
//		}
//
//		self.to_update = queued;
//
//		Ok(changes)
//	}
//}
