// OV FILE
import { useBackend } from 'tgui/backend';
import { Button, Section } from 'tgui-core/components';

export const ControlSmites = (props) => {
  const { act } = useBackend();

  return (
    <Section title="Smites">
      <Button fluid onClick={() => act('lightning_strike')}>
        Lightning Strike
      </Button>
      <Button fluid onClick={() => act('bluespace_artillery')}>
        Bluespace Artillery
      </Button>
      <Button fluid onClick={() => act('brain_damage')}>
        Give Brain Damage
      </Button>
      <Button fluid onClick={() => act('Zesus_Psyst')}>
        Zesus Psyst
      </Button>
      <Button fluid onClick={() => act('CBT')}>
        CBT
      </Button>
      <Button fluid onClick={() => act('snap_neck')}>
        Snap Neck
      </Button>
      <Button fluid onClick={() => act('fracture_arms_and_legs')}>
        Break Arms and Legs
      </Button>
      <Button fluid onClick={() => act('throw_mob')}>
        Throw Mob
      </Button>
      <Button fluid onClick={() => act('liam')}>
        Trey Liam
      </Button>
      <Button fluid onClick={() => act('divine_wrath')}>
        Divine Wrath
      </Button>
      <Button fluid onClick={() => act('spin')}>
        Spin
      </Button>
      <Button fluid onClick={() => act('wet_floors')}>
        Slippery Surroundings
      </Button>
      <Button fluid onClick={() => act('elder_smite')}>
        Elder Smite
      </Button>
      <Button fluid onClick={() => act('item_tf')}>
        Item TF
      </Button>
    </Section>
  );
};
