// OV FILE
import { useState } from 'react';
import { useBackend } from 'tgui/backend';
import { Button, Image, Section, Stack, Table } from 'tgui-core/components';

import { SortButton } from './CharacterDirectorySortButton';
import { getTagColor } from './constants';
import type { mobEntry } from './types';

export const CharacterDirectoryList = (props: {
  directory: mobEntry[];
  onOpenAd: (name: string, ad: string) => void;
}) => {
  const { act } = useBackend();

  const { directory, onOpenAd } = props;

  const [sortId, setSortId] = useState<string>('name');
  const [sortOrder, setSortOrder] = useState<boolean>(true);
  const [hoveredAction, setHoveredAction] = useState<string | null>(null);

  return (
    <Section
      title="Directory"
      buttons={
        <Button icon="sync" onClick={() => act('refresh')}>
          Refresh
        </Button>
      }
    >
      <Table>
        <Table.Row bold>
          <Table.Cell collapsing textAlign="center">
            Photo
          </Table.Cell>
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
            ourId="species"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Species
          </SortButton>
          <SortButton
            ourId="tag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Vore Tag
          </SortButton>
          <SortButton
            ourId="gendertag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Gender
          </SortButton>
          <SortButton
            ourId="sexualitytag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            Sexuality
          </SortButton>
          <SortButton
            ourId="erptag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            ERP Tag
          </SortButton>
          <SortButton
            ourId="pvptag"
            sortId={sortId}
            sortOrder={sortOrder}
            onSortId={setSortId}
            onSortOrder={setSortOrder}
          >
            PvP Opt-In
          </SortButton>
          <Table.Cell collapsing textAlign="center">
            Ad
          </Table.Cell>
          <Table.Cell collapsing textAlign="center">
            View
          </Table.Cell>
        </Table.Row>
        {directory
          .sort((a, b) => {
            const i = sortOrder ? 1 : -1;
            return a[sortId].localeCompare(b[sortId]) * i;
          })
          .map((character, i) => {
            const hasCharacterAd = !!character.character_ad?.trim();
            const adActionId = `${character.ckey}-ad`;
            const viewActionId = `${character.ckey}-view`;

            return (
              <Table.Row key={i} backgroundColor={getTagColor(character.tag)} textColor="black">
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.photo ? (
                    <Stack
                      align="center"
                      justify="center"
                      backgroundColor="black"
                      overflow="hidden"
                    >
                      <Stack.Item>
                        <Image
                          fixErrors
                          src={character.photo.substring(
                            1,
                            character.photo.length - 1,
                          )}
                          height="64px"
                        />
                      </Stack.Item>
                    </Stack>
                  ) : null}
                </Table.Cell>
                <Table.Cell p={1} verticalAlign="middle">
                  {character.name}
                </Table.Cell>
                <Table.Cell verticalAlign="middle">
                  {character.species}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.tag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.gendertag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.sexualitytag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.erptag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" textAlign="center">
                  {character.pvptag}
                </Table.Cell>
                <Table.Cell verticalAlign="middle" collapsing textAlign="center">
                  <Button
                    onClick={() => onOpenAd(character.name, character.character_ad)}
                    onMouseEnter={() => setHoveredAction(adActionId)}
                    onMouseLeave={() => setHoveredAction((current) => current === adActionId ? null : current)}
                    color="transparent"
                    textColor="black"
                    icon="scroll"
                    tooltip={hasCharacterAd ? 'View advertisement' : 'No advertisement set'}
                    disabled={!hasCharacterAd}
                    style={{
                      backgroundColor: hoveredAction === adActionId
                        ? 'rgba(255, 255, 255, 0.16)'
                        : 'transparent',
                      borderRadius: '3px',
                      ...(!hasCharacterAd ? {
                        opacity: 0.55,
                        filter: 'brightness(1.15)',
                      } : undefined),
                    }}
                  />
                </Table.Cell>
                <Table.Cell verticalAlign="middle" collapsing textAlign="center">
                  <Button
                    onClick={() => act('openExamine', { ckey: character.ckey })}
                    onMouseEnter={() => setHoveredAction(viewActionId)}
                    onMouseLeave={() => setHoveredAction((current) => current === viewActionId ? null : current)}
                    color="transparent"
                    textColor="black"
                    icon="eye"
                    tooltip="View character profile"
                    style={{
                      backgroundColor: hoveredAction === viewActionId
                        ? 'rgba(255, 255, 255, 0.16)'
                        : 'transparent',
                      borderRadius: '3px',
                    }}
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
