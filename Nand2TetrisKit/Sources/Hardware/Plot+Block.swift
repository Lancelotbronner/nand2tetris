////
////  Plot+Block.swift
////  Nand2TetrisKit
////
////  Created by Christophe Bronner on 2025-01-12.
////
//
//pub enum Connector {
//	Input(u8),
//	Output(u8),
//}
//
//pub type BlockID = Id;
//
//#[derive(Debug, Serialize, Deserialize, Clone)]
//pub struct Block {
//	id: BlockID,
//	name: String,
//
//	position: Vector2<i32>,
//	size: Vector2<i32>,
//
//	#[serde(skip)]
//	highlighted: bool,
//	unique: bool,
//	passthrough: bool,
//
//	inputs: Vec<Option<ConnectionID>>,
//	outputs: Vec<Option<ConnectionID>>,
//
//	state: State,
//	output_state: u128,
//
//	decoration: Decoration,
//	color: Option<Color>,
//}
//
//impl Identifiable for Block {
//	type ID = BlockID;
//}
//
//impl Block {
//	pub const MAX_CONNECTIONS: u8 = 128;
//
//	pub fn new_sized(
//		module: &&Module,
//		position: Vector2<i32>,
//		unique: bool,
//		num_inputs: u8,
//		num_outputs: u8,
//		color: Option<Color>,
//	) -> Self {
//		let name = module.name().clone();
//		Self {
//			id: Id::new(),
//			position,
//			size: Vector2(
//				cmp::max(75, (name.len() * 10) as i32),
//				cmp::max(num_inputs, num_outputs) as i32 * 25 + 50,
//			),
//			highlighted: false,
//			unique,
//			passthrough: true,
//			inputs: vec![None; num_inputs as usize],
//			outputs: vec![None; num_outputs as usize],
//			name,
//			state: if module.builtin() {
//				State::Direct(0)
//			} else {
//				State::Inherit(PlotState::default())
//			},
//			decoration: module.decoration().clone(),
//			color,
//			output_state: 0,
//		}
//	}
//
//	pub fn new(module: &&Module, position: Vector2<i32>, color: Option<Color>) -> Self {
//		Self::new_sized(
//			module,
//			position,
//			false,
//			module.get_num_inputs(),
//			module.get_num_outputs(),
//			color,
//		)
//	}
//
//
//	pub fn simulate(
//			&mut self,
//			connections: &mut HashMap<ConnectionID, Connection>,
//			to_update: &mut HashSet<BlockID>,
//			queued: &mut HashSet<BlockID>,
//			project: &mut Project,
//			call_stack: &mut HashSet<String>,
//		) -> SimResult<()> {
//			// collect input states
//			let inputs = self.inputs.collect(connections);
//
//			let mut_ref_ptr = project as *mut Project;
//			if let Some(module) = project.module_mut(&self.name) {
//				// simulate the block
//				self.output_state =
//					module.simulate(inputs, self, unsafe { &mut *mut_ref_ptr }, call_stack)?;
//
//				// dissect output state
//				for (i, connection_id) in self.outputs.iter().enumerate() {
//					if let Some(connection) = connection_id
//						.map(|connection_id| connections.get_mut(&connection_id))
//						.flatten()
//					{
//						let active = (self.output_state >> i as u128) & 1 != 0;
//						if active != connection.is_active() {
//							for dest_id in connection.destinations().iter().map(|dest| dest.block_id())
//							{
//								if dest_id == self.id {
//									queued.insert(dest_id);
//								} else {
//									to_update.insert(dest_id);
//								}
//							}
//							connection.set_active(active);
//						}
//					}
//				}
//			} else {
//				error!("no module named {} found", self.name);
//			}
//
//			Ok(())
//		}
