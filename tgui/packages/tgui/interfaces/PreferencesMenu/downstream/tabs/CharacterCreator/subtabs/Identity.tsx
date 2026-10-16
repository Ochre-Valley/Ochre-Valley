import { useBackendStrict } from 'tgui/backend';
import { Button, LabeledList, Section, Stack } from 'tgui-core/components';
import type { BooleanLike } from 'tgui-core/react';

export const SubtabIdentityDownstreamPaneLeft = () => {
  // Suggested format:
  // return (
  //   <>
  //     <Stack.Item>
  //       <MyCardHere />
  //     </Stack.Item>
  //     <Stack.Item>
  //       <MyCardHere2 />
  //     </Stack.Item>
  //   </>
  // )

  return (
    <Stack.Item>
      <PrefBadges />
    </Stack.Item>
  );
};

export const SubtabIdentityDownstreamPaneRight = () => {
  // Suggested format:
  // return (
  //   <>
  //     <Stack.Item>
  //       <MyCardHere />
  //     </Stack.Item>
  //     <Stack.Item>
  //       <MyCardHere2 />
  //     </Stack.Item>
  //   </>
  // )

  return (
    <Stack.Item>
      <CharDirectory />
    </Stack.Item>
  );
};

type PrefBadgesData = {
  directory_pvp: string;
  badge_gng: string;
  badge_vore: string;
  badge_willing: string;
  badge_sexuality: string;
  badge_erp: string;
  badge_lean: string;
  badge_type: string;
};

const PrefBadges = (props: any) => {
  const { act, data } = useBackendStrict<PrefBadgesData>();
  const {
    directory_pvp,
    badge_gng,
    badge_vore,
    badge_willing,
    badge_sexuality,
    badge_erp,
    badge_lean,
    badge_type,
  } = data;
  return (
    <Section title="Pref Badges">
      <LabeledList>
        <LabeledList.Item label="PvP Opt In">
          <Button fluid onClick={() => act('pvp_opt_in')}>
            {directory_pvp || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Grab and Gulp">
          <Button fluid onClick={() => act('choose_grab_and_gulp')}>
            {badge_gng || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Digest/Absorb/Endo">
          <Button fluid onClick={() => act('choose_vore_pref')}>
            {badge_vore || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Willingness">
          <Button fluid onClick={() => act('choose_willingness')}>
            {badge_willing || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Scene Partner Pref">
          <Button fluid onClick={() => act('choose_sexuality')}>
            {badge_sexuality || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Allow non-vore ERP">
          <Button fluid onClick={() => act('choose_erp_pref')}>
            {badge_erp || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Pred/Prey lean">
          <Button fluid onClick={() => act('choose_vore_lean')}>
            {badge_lean || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Vore Methods">
          <Button fluid onClick={() => act('choose_vore_type')}>
            {badge_type || 'Unset'}
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};

type CharDirectoryData = {
  show_in_directory: BooleanLike;
  directory_tag: string;
  directory_erptag: string;
  directory_gendertag: string;
  directory_sexualitytag: string;
};

const CharDirectory = (props: any) => {
  const { act, data } = useBackendStrict<CharDirectoryData>();
  const {
    show_in_directory,
    directory_tag,
    directory_erptag,
    directory_gendertag,
    directory_sexualitytag,
  } = data;
  return (
    <Section title="Character Directory">
      <LabeledList>
        <LabeledList.Item label="Show In Directory">
          <Button fluid onClick={() => act('show_in_directory')}>
            {show_in_directory ? 'Yes' : 'No'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Vore Pref Tag">
          <Button fluid onClick={() => act('directory_tag')}>
            {directory_tag || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="ERP Pref Tag">
          <Button fluid onClick={() => act('directory_erptag')}>
            {directory_erptag || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Gender Tag">
          <Button fluid onClick={() => act('directory_gendertag')}>
            {directory_gendertag || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Sexuality Tag">
          <Button fluid onClick={() => act('directory_sexualitytag')}>
            {directory_sexualitytag || 'Unset'}
          </Button>
        </LabeledList.Item>
        <LabeledList.Item label="Directory Ad">
          <Button fluid onClick={() => act('directory_ad')}>
            Edit
          </Button>
        </LabeledList.Item>
      </LabeledList>
    </Section>
  );
};
