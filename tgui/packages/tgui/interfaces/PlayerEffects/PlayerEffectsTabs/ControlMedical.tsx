// OV FILE
import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlMedical = (props: any) => {
  const { act } = useBackend();

  return (
    <Section title="Medical Effects">
      <Button fluid onClick={() => act('health_scan')}>
        Health Analysis
      </Button>
      <Button fluid onClick={() => act('give_chem')}>
        Give Reagent
      </Button>
      <Button fluid onClick={() => act('purge')}>
        Purge Reagents
      </Button>
      <Button fluid onClick={() => act('full_heal')}>
        Full Heal
      </Button>
      <Button fluid onClick={() => act('revive')}>
        Revive
      </Button>
    </Section>
  );
};
