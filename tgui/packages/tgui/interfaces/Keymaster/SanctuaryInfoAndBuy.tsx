// OV FILE
import {
  cardStyle,
  inkButtonStyle,
  pageStyle,
  rulerStyle,
  SEAL_AMBER,
  sectionHeaderStyle,
} from '../common/parchment';
import { Box, Button, Stack } from 'tgui-core/components';
import { SanctuaryData } from './types';

export const SanctuaryInfoAndBuy = (props: {
  can_read: boolean;
  stored_money: number;
  selected_sanctuary: SanctuaryData;
  onBuySanctuary: () => void;
  already_owns_sanctuary: boolean;
  is_generating_for_us: boolean;
  is_showing_confirm_option: boolean;
  onShowConfirmPrompt: () => void;
}) => {
  const { selected_sanctuary: selected_sanctuary_data,
    stored_money,
    onBuySanctuary,
    already_owns_sanctuary,
    is_generating_for_us,
    is_showing_confirm_option,
    onShowConfirmPrompt
  } = props;
  const tooExpensive: boolean = selected_sanctuary_data.price > stored_money
  return (
    <Stack vertical fill scrollable>
      <Stack.Item basis={"60%"}>
        <Box style={cardStyle} height={"100%"} width={"100%"}>
          <div style={sectionHeaderStyle}>
            {selected_sanctuary_data.name}
          </div>
          <div style={pageStyle}>
            {selected_sanctuary_data.description}<br/>
            <hr style={rulerStyle} />
            <b>COST:{' '}</b>
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {selected_sanctuary_data.price}m
            </span>
          </div>
        </Box>
      </Stack.Item>
      <Stack.Item>
        <Button
          style={inkButtonStyle({
            disabled: is_generating_for_us || already_owns_sanctuary || tooExpensive,
            color: is_showing_confirm_option ? "#b13834" : undefined})}
          fluid
          onClick={is_showing_confirm_option ? () => onBuySanctuary() : () => onShowConfirmPrompt()}
          disabled={tooExpensive || is_generating_for_us || already_owns_sanctuary}
          m={1}
        >
          {is_generating_for_us ? "FORGING THY SANCTUARY KEYS, WAIT A MOTE..."
          : already_owns_sanctuary ? "SORRY, ONLY ONE SANCTUARY PER CUSTOMER"
          : tooExpensive ? "CANNOT PURCHASE (INSERT MORE COIN, DISCERNER)"
          : is_showing_confirm_option? "CONFIRM PURCHASE? (ONE SANCTUARY PER BUYER PER WEEK)"
          : "PURCHASE THIS REMOTE SANCTUARY"}
        </Button>
      </Stack.Item>
    </Stack>
  )
}
