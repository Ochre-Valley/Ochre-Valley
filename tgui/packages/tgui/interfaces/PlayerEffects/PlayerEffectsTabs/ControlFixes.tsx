// OV FILE
import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlFixes = (props: any) => {
  const { act } = useBackend();

  return (
    <Section title="Bug Fixes">
      <Button fluid onClick={() => act('rejuvenate')}>
        Rejuvenate
      </Button>
      <Button fluid onClick={() => act('popup-box')}>
        Send Message Box
      </Button>
      <Button fluid onClick={() => act('clear_all_status')}>
        Clear All Status
      </Button>
    </Section>
  );
};
