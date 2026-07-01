//OV File
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Section, Button, Image, Stack, Table, Dropdown } from 'tgui-core/components';

import { playerEntry } from "./types";
import { SortButton } from "../CharacterDirectory/CharacterDirectorySortButton";

const STATE_DICT = ["Conscious", "Soft-Crit", "Unconscious", "Dead"];

export const AdminManifestList = (props: {
  directory: playerEntry[];
}) => {
  const { act } = useBackend();
  const [selectedCat, setSelectedCat] = useState<string>('None');
  const [sortId, setSortId] = useState<string>('ckey');
  const [sortOrder, setSortOrder] = useState<boolean>(true);
  const { directory } = props;
  return(
    <Section
          title="Directory"
          buttons={
            <Stack vertical={false}>
              <Dropdown
              onSelected={(a) => setSelectedCat(a)}
              options={["None", "Ducal Family", "Courtiers", "Retinue", "Garrison", "Church", "Burgher", "Peasant", "Sidefolk", "Inquisition", "Wanderer", "Nobodies"]}
              selected={selectedCat}
              icon="filter"
              />
              <Button icon="sync" onClick={() => act('refresh')}>
                Refresh
              </Button>
            </Stack>
          }
    >
    <Table>
      <Table.Row bold>
        <Table.Cell collapsing textAlign="center">
          Photo
        </Table.Cell>
        <SortButton
          ourId="ckey"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        CKey
        </SortButton>
        <SortButton
          ourId="name"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        Name
        </SortButton>
        <SortButton
          ourId="job"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        Job
        </SortButton>
        <SortButton
          ourId="category"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        Category
        </SortButton>
        <SortButton
          ourId="afk"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        AFK
        </SortButton>
        <SortButton
          ourId="state"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        State
        </SortButton>
        <SortButton
          ourId="antag"
          sortId={sortId}
          sortOrder={sortOrder}
          onSortId={setSortId}
          onSortOrder={setSortOrder}
        >
        Antag Status
        </SortButton>
        <Table.Cell collapsing textAlign="center">
          View Player Panel
        </Table.Cell>
      </Table.Row>
      {directory
          .filter((player) => {
            return selectedCat === "None" ? true : (player.category === selectedCat);
          })
          .sort((a, b) => {
            const i = sortOrder ? 1 : -1;
            return String(a[sortId]).localeCompare(String(b[sortId])) * i;
          })
          .map((player, i) => {
            return (
              <Table.Row key={i} className='candystripe'>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {player.photo ? (
                    <Stack
                      align="center"
                      justify="center"
                      backgroundColor="black"
                      overflow="hidden"
                    >
                      <Stack.Item>
                        <Image
                          fixErrors
                          src={player.photo.substring(
                            1,
                            player.photo.length - 1,
                          )}
                          height="64px"
                        />
                      </Stack.Item>
                    </Stack>
                  ) : null}
                </Table.Cell>
                <Table.Cell p={1} verticalAlign="middle">
                  {player.ckey}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {player.name}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {player.job}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {player.category}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {player.afk}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {STATE_DICT[player.state]}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {player.antag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" collapsing textAlign="center">
                  <Button
                    onClick={() => act('playerPanel', { ckey: player.ckey })}
                    color="transparent"
                    icon="eye"
                    tooltip="View player panel"
                  />
                </Table.Cell>
              </Table.Row>
            );
          })
      }
    </Table>
    </Section>
  );
};
