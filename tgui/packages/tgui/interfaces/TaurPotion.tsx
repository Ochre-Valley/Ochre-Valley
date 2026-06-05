import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, ColorBox, Section, Stack } from 'tgui-core/components';

import { ColorizedImage, CustomImageButton } from './common/CanvasHelpers';

type AllTaurData = TaurData & TaurStaticData;

type TaurData = {
  taur_type: string;
  taur_color: string;
};

type TaurStaticData = {
  taurs: TaurTail[];
};

type TaurTail = {
  name: string;
  path: string;
  icon: string;
  icon_state: string;
};

const TaurTailIcon = (props: {
  taur: TaurTail;
  color: string;
  dir: string;
}) => {
  const { taur, color, dir } = props;

  return (
    <ColorizedImage
      iconRef={taur.icon}
      iconState={taur.icon_state}
      color={color}
      colorBlendingMode="multiply"
      height={32 * 2}
      width={64 * 2}
      dir={dir}
    />
  );
};

const TaurTailButton = (props: {
  taur: TaurTail;
  color: string;
  selected: boolean;
}) => {
  const { act } = useBackend();
  const { taur, color, selected } = props;
  return (
    <CustomImageButton
      fluid
      image={
        <>
          <TaurTailIcon color={color} taur={taur} dir={'2'} />
          <TaurTailIcon color={color} taur={taur} dir={'4'} />
        </>
      }
      onClick={() => act('change_taur_type', { type: taur.path })}
      selected={selected}
    >
      <Box align="right" fontSize={1.2}>
        {taur.name}
      </Box>
    </CustomImageButton>
  );
};

export const TaurPotion = () => {
  const { act, data } = useBackend<AllTaurData>();
  const { taur_type, taur_color, taurs } = data;

  const current_taur_type = taurs.find((v) => v.path === taur_type) || {
    name: 'Regular Legs',
    path: '',
    icon: '',
    icon_state: '',
  };

  taurs.sort((a, b) => a.name.localeCompare(b.name));

  return (
    <Window title="Taur Potion" width={580} height={520}>
      <Window.Content>
        <Stack fill vertical>
          <Stack.Item basis="15%">
            <Stack fill align="center" justify="space-between">
              <Stack.Item basis="33%">
                <Stack vertical fill align="flex-start">
                  <Stack.Item>Currently Selected</Stack.Item>
                  <Stack.Item fontSize={1.2}>
                    {current_taur_type.name}
                  </Stack.Item>
                </Stack>
              </Stack.Item>
              {current_taur_type.icon ? (
                <Stack.Item basis="33%">
                  <Stack fill align="center" justify="center">
                    <Stack.Item>
                      <Stack fill>
                        <Stack.Item>
                          <TaurTailIcon
                            color={taur_color}
                            taur={current_taur_type}
                            dir="2"
                          />
                        </Stack.Item>
                        <Stack.Item>
                          <TaurTailIcon
                            color={taur_color}
                            taur={current_taur_type}
                            dir="4"
                          />
                        </Stack.Item>
                      </Stack>
                    </Stack.Item>
                  </Stack>
                </Stack.Item>
              ) : null}
              <Stack.Item basis="33%">
                <Stack vertical fill align="flex-end">
                  <Stack.Item>Color</Stack.Item>
                  <Stack.Item fontSize={1.2}>
                    <Button onClick={() => act('change_taur_color')}>
                      <ColorBox color={taur_color} />
                    </Button>
                  </Stack.Item>
                </Stack>
              </Stack.Item>
            </Stack>
          </Stack.Item>
          <Stack.Item grow>
            <Section fill scrollable>
              <Stack vertical>
                <Stack.Item>
                  <CustomImageButton
                    fluid
                    image={<Box />}
                    onClick={() => act('change_taur_type_legs')}
                    selected={taur_type === 'legs'}
                  >
                    <Box align="right" fontSize={1.2}>
                      Regular Legs
                    </Box>
                  </CustomImageButton>
                </Stack.Item>
                {taurs.map((tail) => (
                  <Stack.Item key={tail.path}>
                    <TaurTailButton
                      color={taur_color}
                      selected={tail.path === taur_type}
                      taur={tail}
                    />
                  </Stack.Item>
                ))}
              </Stack>
            </Section>
          </Stack.Item>
        </Stack>
      </Window.Content>
    </Window>
  );
};
