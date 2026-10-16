import { LabeledGridList } from 'pm/components';
import type {
  Customizer,
  CustomizerChoice,
} from 'pm/tabs/CharacterCreator/data';
import { useBackendStrict } from 'tgui/backend';
import { Button, Stack } from 'tgui-core/components';

export interface ButtCustomizer extends CustomizerChoice {
  butt_size: string;
}

export const FeatureChoiceButt = (props: { customizer: Customizer }) => {
  const { customizer } = props;
  const { act } = useBackendStrict();
  const { choices } = customizer;
  const { butt_size } = choices as ButtCustomizer;

  return (
    <Stack.Item>
      <LabeledGridList>
        <LabeledGridList.Item label="Butt Size">
          <Button
            fluid
            onClick={() =>
              act('change_customizer', {
                customizer: customizer.type,
                customizer_task: 'butt_size',
              })
            }
          >
            {butt_size}
          </Button>
        </LabeledGridList.Item>
      </LabeledGridList>
    </Stack.Item>
  );
};
