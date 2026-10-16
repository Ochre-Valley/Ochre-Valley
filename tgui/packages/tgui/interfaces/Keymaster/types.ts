// OV FILE
export type SanctuaryData = {
	name: string;
  id: string;
  description: string;
  subtitle: string;
  width: number;
  height: number;
  floors: number;
  price: number;
};

export type Data = {
  can_read: boolean;
  available_sanctuaries_data: SanctuaryData[];
  stored_money: number;
  selected_sanctuary: SanctuaryData;
  already_owns_sanctuary: boolean;
  is_generating_for_us: boolean;
  is_showing_confirm_option: boolean;
}
