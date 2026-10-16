// OV FILE
import {
  cardStyle,
  rulerStyle,
  SEAL_AMBER,
  subtitleStyle,
  titleStyle,
} from '../common/parchment';
import { Box, Button, Stack} from 'tgui-core/components';
import { Window } from 'tgui/layouts';
import { Data } from './types';
import { useBackend } from 'tgui/backend';
import { SanctuaryOptions } from './SanctuaryOptions';
import { SanctuaryInfoAndBuy } from './SanctuaryInfoAndBuy';

export const starsIf = (text: string, canRead: boolean) =>
  canRead ? text : text.replace(/[A-Za-z0-9]/g, '*');

export const Keymaster = (props: {
}) => {
  const { act, data } = useBackend<Data>();
  const can_read = !!data.can_read;
  const { stored_money, selected_sanctuary: selected_sanctuary, already_owns_sanctuary, is_generating_for_us, is_showing_confirm_option } = data;
  const sortedSanctuaries = data.available_sanctuaries_data.sort((a, b) => a.name.toLowerCase().localeCompare(b.name.toLowerCase()));
  return (
    <Window width={820} height={760} theme="parchment">
      <Window.Content>
        <Box m={2}>
          <div style={titleStyle}>THE KEYMASTER</div>
          <div style={subtitleStyle}>
            Thy balance:{' '}
            <span style={{ color: SEAL_AMBER, fontWeight: 'bold' }}>
              {stored_money}m
            </span>
            {' '}
            <Button icon="coins" onClick={() => {act('refund_money')}}>
              Refund
            </Button>
          </div>
        </Box>
        <hr style={rulerStyle} />
        <div style={subtitleStyle}>FOR THEE, COIN-SAVVY DISCERNER, WE OFFER THESE LANDS FAR:</div>
        <Stack fill height="100%">
          <Stack.Item basis="40%" m={2} mr={0} >
            <Box height="78%" style={cardStyle} align>
              <SanctuaryOptions
                can_read={can_read}
                sortedSanctuaries={sortedSanctuaries}
                selected_sanctuary={selected_sanctuary}
                onSelectSanctuary= {(sanctuary_id: string) => {act('select_sanctuary', { selected_id: sanctuary_id })}}
              />
            </Box>
          </Stack.Item>
          <Stack.Item basis="60%" m={2} ml={0}>
            <SanctuaryInfoAndBuy
              can_read={can_read}
              stored_money={stored_money}
              onBuySanctuary={() => act('purchase_sanctuary')}
              selected_sanctuary={selected_sanctuary}
              already_owns_sanctuary={already_owns_sanctuary}
              is_generating_for_us={is_generating_for_us}
              is_showing_confirm_option={is_showing_confirm_option}
              onShowConfirmPrompt={() => act('open_confirm_choice')}
            />
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
