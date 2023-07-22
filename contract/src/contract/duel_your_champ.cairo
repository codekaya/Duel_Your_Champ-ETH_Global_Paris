use starknet::StorageAccess;
use starknet::StorageBaseAddress;
use starknet::SyscallResult;
use starknet::storage_access;
use starknet::storage_read_syscall;
use starknet::storage_write_syscall;
use starknet::storage_base_address_from_felt252;
use starknet::storage_address_from_base_and_offset;
use traits::Into;
use traits::TryInto;
use option::OptionTrait;

use starknet::contract_address_const;
use starknet::ContractAddress;

#[abi]
trait prng {
    fn update() -> u128;
}

#[abi]
trait ERC721ABI {
    #[view]
    fn owner_of(token_id: u256) -> ContractAddress;
}


#[derive(Copy, Drop, Serde)] 
struct Game {
    name: felt252,
    nft_collection_address: ContractAddress,
    winner: ContractAddress,
    turn_duration: u64,
    num_players: u16,
    start_time: u64,
    is_active: bool,
    current_tour: u8,
}

#[derive(Copy, Drop, Serde)] 
struct Player {
    health: u16,
    name: felt252,
    address: ContractAddress,
    nft_collection_address: ContractAddress,
    nft_collection_token_id: u16,
    move_turn: u8,
    is_alive: bool,
    move: u8
}

impl GameStorageAccess of StorageAccess::<Game> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<Game> {

        let name = StorageAccess::read(address_domain, base)?;

        let nft_collection_address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 1_u8).into());
        let nft_collection_address = StorageAccess::read(address_domain, nft_collection_address_base)?;

        let winner_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 2_u8).into());
        let winner = StorageAccess::read(address_domain, winner_base)?;

        let turn_duration_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 3_u8).into());
        let turn_duration = StorageAccess::read(address_domain, turn_duration_base)?;

        let num_players_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 4_u8).into());
        let num_players = StorageAccess::read(address_domain, num_players_base)?;

        let start_time_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 5_u8).into());
        let start_time = StorageAccess::read(address_domain, start_time_base)?;

        let is_active_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 6_u8).into());
        let is_active = StorageAccess::read(address_domain, is_active_base)?;

        let current_tour_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 7_u8).into());
        let current_tour = StorageAccess::read(address_domain, current_tour_base)?;

        Result::Ok(Game { name , nft_collection_address, winner, turn_duration, num_players, start_time, is_active, current_tour })

    }

    fn write(address_domain: u32, base: StorageBaseAddress, value: Game) -> SyscallResult::<()> {
        StorageAccess::write(address_domain, base, value.name)?;

        let nft_collection_address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 1_u8).into());
        StorageAccess::write(address_domain, nft_collection_address_base, value.nft_collection_address)?;

        let winner_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 2_u8).into());
        StorageAccess::write(address_domain, winner_base, value.winner)?;

        let turn_duration_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 3_u8).into());
        StorageAccess::write(address_domain, turn_duration_base, value.turn_duration)?;

        let num_players_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 4_u8).into());
        StorageAccess::write(address_domain, num_players_base, value.num_players)?;

        let start_time_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 5_u8).into());
        StorageAccess::write(address_domain, start_time_base, value.start_time)?;

        let is_active_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 6_u8).into());
        StorageAccess::write(address_domain, is_active_base, value.is_active)?;

        let current_tour_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 7_u8).into());
        StorageAccess::write(address_domain, current_tour_base, value.current_tour)

    }
}

impl PlayerStorageAccess of StorageAccess::<Player> {
    fn read(address_domain: u32, base: StorageBaseAddress) -> SyscallResult::<Player> {

        let health = StorageAccess::read(address_domain, base)?;

        let name_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 1_u8).into());
        let name = StorageAccess::read(address_domain, name_base)?;

        let address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 2_u8).into());
        let address = StorageAccess::read(address_domain, address_base)?;

        let nft_collection_address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 3_u8).into());
        let nft_collection_address = StorageAccess::read(address_domain, nft_collection_address_base)?;

        let nft_collection_token_id_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 4_u8).into());
        let nft_collection_token_id = StorageAccess::read(address_domain, nft_collection_token_id_base)?;

        let move_turn_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 5_u8).into());
        let move_turn = StorageAccess::read(address_domain, move_turn_base)?;

        let is_alive_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 6_u8).into());
        let is_alive = StorageAccess::read(address_domain, is_alive_base)?;

        let move_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 7_u8).into());
        let move = StorageAccess::read(address_domain, move_base)?;

        Result::Ok(Player {health, name, address, nft_collection_address, nft_collection_token_id, move_turn, is_alive, move})

    }

    fn write(address_domain: u32, base: StorageBaseAddress, value: Player) -> SyscallResult::<()> {
        StorageAccess::write(address_domain, base, value.health)?;

        let name_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 1_u8).into());
        StorageAccess::write(address_domain, name_base, value.name)?;

        let address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 2_u8).into());
        StorageAccess::write(address_domain, address_base, value.address)?;

        let nft_collection_address_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 3_u8).into());
        StorageAccess::write(address_domain, nft_collection_address_base, value.nft_collection_address)?;

        let nft_collection_token_id_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 4_u8).into());
        StorageAccess::write(address_domain, nft_collection_token_id_base, value.nft_collection_token_id)?;

        let move_turn_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 5_u8).into());
        StorageAccess::write(address_domain, move_turn_base, value.move_turn)?;

        let is_alive_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 6_u8).into());
        StorageAccess::write(address_domain, is_alive_base, value.is_alive)?;
        
        let move_base = storage_base_address_from_felt252(storage_address_from_base_and_offset(base, 7_u8).into());
        StorageAccess::write(address_domain, move_base, value.move)

    }
}



#[contract]
mod duel_your_champ {

    use starknet::ContractAddress;
    use starknet::StorageAccess;
    use starknet::get_contract_address;
    use starknet::get_caller_address;
    use starknet::contract_address_const;
    use starknet::get_block_timestamp;
    use traits::TryInto;
    use traits::Into;
    use option::OptionTrait;
    use super::Game;
    use super::Player;


    struct Storage {
        games: LegacyMap::<u256, Game >,
        game_count: u256,
        players: LegacyMap::<(u256,u16), Player >,
        owner: ContractAddress,

    }


    #[constructor]
    fn constructor() {
        game_count::write(0_u256);
        let address = contract_address_const::<0x00b42717976be9f43281e55e2420e6c41517cfd79076a7705fa3e91656d35bfb>();
        owner::write(address);
    }

    #[view]
    fn get_game_count() -> u256 {
        return game_count::read();
    }

    #[external]
    fn create_game(amount: felt252) {
        assert(amount != 0, 'Amount cannot be 0');
    }

    #[external]
    fn join_game(amount: felt252) {
        assert(amount != 0, 'Amount cannot be 0');
    }  
    


}
