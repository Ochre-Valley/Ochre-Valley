import { useBackend } from 'tgui/backend';
import { Window } from 'tgui/layouts';
import { AdminManifestList } from './AdminManifestList';

import type { Data } from './types';

const MANIFEST_WINDOW_WIDTH = Math.round(816 * 1.15);
const MANIFEST_WINDOW_HEIGHT = Math.round(722 * 1.15);

export const AdminManifest = (props) => {
  const { data } = useBackend<Data>();
  const { directory } = data;

  return (
    <Window
      width={MANIFEST_WINDOW_WIDTH}
      height={MANIFEST_WINDOW_HEIGHT}
    >
        <Window.Content scrollable>
          <AdminManifestList 
            directory={directory}
          />
        </Window.Content>
    </Window>
  );
};
