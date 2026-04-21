// OV FILE
import { useMemo, useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { Box, Button, LabeledList, Section, Stack } from 'tgui-core/components';

import { CharacterDirectoryList } from './CharacterDirectoryList';
import type { Data } from './types';

const CHARACTER_DIRECTORY_WINDOW_WIDTH = Math.round(816 * 1.15);
const CHARACTER_DIRECTORY_WINDOW_HEIGHT = Math.round(722 * 1.15);

export const CharacterDirectory = (props) => {
  const { act, data } = useBackend<Data>();

  const {
    personalVisibility,
    personalTag,
    personalGenderTag,
    personalSexualityTag,
    personalErpTag,
    personalPvPTag,
    personalEventTag,
    directory,
  } = data;

  const [overwritePrefs, setOverwritePrefs] = useState<boolean>(false);
  const [directoryAd, setDirectoryAd] = useState<string | null>(null);
  const [directoryAdName, setDirectoryAdName] = useState<string>('');
  const directoryAdHTML = useMemo(() => ({
    __html: directoryAd || '',
  }), [directoryAd]);
  const closeDirectoryAd = () => {
    setDirectoryAd(null);
    setDirectoryAdName('');
  };

  return (
    <Window
      width={CHARACTER_DIRECTORY_WINDOW_WIDTH}
      height={CHARACTER_DIRECTORY_WINDOW_HEIGHT}
    >
      <Window.Content scrollable>
        {/*
          Old/redundant in-directory description overlay retained for reference.
          We now open the shared Examine Panel instead so directory views match
          in-person "Examine closer" rendering.

        {(overlay && (
          <ViewCharacter overlay={overlay} onOverlay={setOverlay} />
        )) || (
        */}
        <Box>
          <Section
            title="Settings and Preferences"
            buttons={
              <Stack>
                <Stack.Item>
                  <Box color="label" inline>
                    Save to current preferences slot:&nbsp;
                  </Box>
                </Stack.Item>
                <Stack.Item>
                  <Button
                    icon={overwritePrefs ? 'toggle-on' : 'toggle-off'}
                    selected={overwritePrefs}
                    onClick={() => setOverwritePrefs(!overwritePrefs)}
                  >
                    {overwritePrefs ? 'On' : 'Off'}
                  </Button>
                </Stack.Item>
              </Stack>
            }
          >
            <LabeledList>
              <LabeledList.Item label="Visibility">
                <Button
                  fluid
                  onClick={() =>
                    act('setVisible', { overwrite_prefs: overwritePrefs })
                  }
                >
                  {personalVisibility ? 'Shown' : 'Not Shown'}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Vore Tag">
                <Button
                  fluid
                  onClick={() =>
                    act('setTag', { overwrite_prefs: overwritePrefs })
                  }
                >
                  {personalTag}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Gender">
                <Button
                  fluid
                  onClick={() =>
                    act('setGenderTag', { overwrite_prefs: overwritePrefs })
                  }
                >
                  {personalGenderTag}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Sexuality">
                <Button
                  fluid
                  onClick={() =>
                    act('setSexualityTag', {
                      overwrite_prefs: overwritePrefs,
                    })
                  }
                >
                  {personalSexualityTag}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="ERP Tag">
                <Button
                  fluid
                  onClick={() =>
                    act('setErpTag', { overwrite_prefs: overwritePrefs })
                  }
                >
                  {personalErpTag}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="PvP Opt-in">
                <Button
                  fluid
                  onClick={() =>
                    act('setPvPTag', { overwrite_prefs: overwritePrefs })
                  }
                >
                  {personalPvPTag}
                </Button>
              </LabeledList.Item>
              <LabeledList.Item label="Advertisement">
                <Button
                  fluid
                  onClick={() =>
                    act('editAd', { overwrite_prefs: overwritePrefs })
                  }
                >
                  Edit Ad
                </Button>
              </LabeledList.Item>
            </LabeledList>
          </Section>
          <CharacterDirectoryList
            directory={directory}
            onOpenAd={(name, ad) => {
              setDirectoryAdName(name);
              setDirectoryAd(ad);
            }}
          />
        </Box>
        {/*
        )}
        */}
      </Window.Content>
      {!!directoryAd?.trim() && (
        <Box
          style={{
            position: 'absolute',
            top: 0,
            left: 0,
            right: 0,
            bottom: 0,
            backgroundColor: 'rgba(0, 0, 0, 0.78)',
            zIndex: 3,
            display: 'flex',
            alignItems: 'center',
            justifyContent: 'center',
            padding: '1.5rem',
          }}
        >
          <Section
            title={`${directoryAdName} Advertisement`}
            fill
            fitted
            scrollable
            style={{
              width: '70%',
              height: '65%',
              maxWidth: '48rem',
              maxHeight: '36rem',
            }}
            buttons={
              <Button
                icon="times"
                color="red"
                onClick={closeDirectoryAd}
              >
                Close
              </Button>
            }
          >
            <Box
              backgroundColor="black"
              p={2}
              style={{
                border: '1px solid rgba(138, 92, 92, 0.85)',
                borderRadius: '0.2rem',
                minHeight: '100%',
                overflowWrap: 'break-word',
              }}
            >
              <Box
                preserveWhitespace
                dangerouslySetInnerHTML={directoryAdHTML}
              />
            </Box>
          </Section>
        </Box>
      )}
    </Window>
  );
};
