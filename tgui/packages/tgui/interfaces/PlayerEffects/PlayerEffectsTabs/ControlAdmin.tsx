// OV FILE
import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlAdmin = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Admin Controls">
      <Button fluid onClick={() => act('teleport')}>
        Teleport
      </Button>
      <Button fluid onClick={() => act('gib')}>
        Gib
      </Button>
      <Button fluid onClick={() => act('dust')}>
        Dust
      </Button>
      <Button fluid onClick={() => act('subtle_message')}>
        Subtle Message
      </Button>
      <Button fluid onClick={() => act('direct_narrate')}>
        Direct Narrate
      </Button>
      <Button fluid onClick={() => act('view_variables')}>
        Open View Variables
      </Button>
      <Button fluid onClick={() => act('orbit')}>
        Make Marked Datum Orbit
      </Button>
      <Button fluid onClick={() => act('make_quest_item')}>
        Turn Into Quest Target
      </Button>
      <Button fluid onClick={() => act('check_traits')}>
        Check Traits
      </Button>
    </Section>
  );
};
