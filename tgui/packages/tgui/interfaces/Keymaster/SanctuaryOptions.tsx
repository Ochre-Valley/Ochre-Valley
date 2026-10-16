// OV FILE
import {
  FONT_HEAD,
  FONT_SMALL,
  INK_FAINT,
  INK_SOFT,
  inkButtonStyle,
  PARCHMENT,
  PARCHMENT_DEEP,
} from '../common/parchment';
import { Button, Stack } from 'tgui-core/components';
import { SanctuaryData } from './types';

export const SanctuaryOptions = (props: {
  can_read: boolean;
  sortedSanctuaries: SanctuaryData[];
  selected_sanctuary: SanctuaryData;
  onSelectSanctuary: (sanctuary_id: string) => void;
}) => {
  const { onSelectSanctuary, can_read, selected_sanctuary, sortedSanctuaries } = props
  function getSanctuaryButton(sanctuary_data: SanctuaryData) {
      let selected = (sanctuary_data.id === selected_sanctuary.id);
      return (
        <Stack.Item>
          <Button
            fluid
            onClick = {() => {onSelectSanctuary(sanctuary_data.id)}}
            style={inkButtonStyle({color: selected ? PARCHMENT_DEEP : PARCHMENT})}
            //style={inkButtonStyle({color: selected ? PARCHMENT_DEEP : PARCHMENT})}
            selected={selected}
            //backgroundColor={selected ? PARCHMENT_DEEP : PARCHMENT}
          >
            <div style={{
              textAlign: 'center',
              color: INK_SOFT,
              fontStyle: 'italic',
              fontSize: FONT_HEAD,
            }}>
              {sanctuary_data.name}
            </div>
            <div style={{
              textAlign: 'center',
              color: INK_FAINT,
              fontStyle: 'italic',
              fontSize: FONT_SMALL,
              marginBottom: '10px',
            }}>
              {sanctuary_data.subtitle}
            </div>
          </Button>
        </Stack.Item>
      );
    }


    function getAllButtons() {
      let ret: import("react").JSX.Element[] = [];
      sortedSanctuaries.forEach(element => {
        ret.push(getSanctuaryButton(element))
      });
      return ret;
    };

  return (
    <Stack vertical fill scrollable >
      {getAllButtons()}
    </Stack>
  )
}
