import { useBackendStrict } from 'tgui/backend';
import { HeadshotButton } from 'tgui/interfaces/PreferencesMenu/components';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';

export const SubtabVillainDownstream = () => {
  // Suggested format:
  // return (
  //   <>
  //     <Stack.Item>
  //       <MySectionHere />
  //     </Stack.Item>
  //     <Stack.Item>
  //       <MySectionHere2 />
  //     </Stack.Item>
  //   </>
  // )

  return (
    <Stack.Item>
      <Werewolf />
    </Stack.Item>
  );
};

type WerewolfData = {
  werewolf_headshot_link: string;
  werewolf_setname: string;
  werewolf_setdesc: string;
};
const Werewolf = (props: any) => {
  const { act, data } = useBackendStrict<WerewolfData>();
  const { werewolf_headshot_link, werewolf_setname, werewolf_setdesc } = data;
  return (
    <Section title="Werewolf Prefs">
      <HeadshotButton
        action="werewolf_headshot_link"
        link={werewolf_headshot_link}
        subtitle="Werewolf Headshot"
        tooltipPosition="bottom-start"
        tooltip="Overrides your default headshot when you are a werewolf."
      />
      <LabeledList>
        <LabeledList.Item label="Werewolf Name">
          <Button
            fluid
            style={{
              wordBreak: 'break-word',
              whiteSpace: 'wrap',
            }}
            onClick={() => act('werewolf_setname')}
          >
            {werewolf_setname || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Werewolf Description">
          <Button fluid onClick={() => act('werewolf_setdesc')}>
            Edit
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
