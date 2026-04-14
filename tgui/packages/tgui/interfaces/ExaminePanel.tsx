// OV Edit Start
import { useEffect, useMemo, useState } from 'react';
import { Box, Button, Section, Stack } from 'tgui-core/components';
// OV Edit End

import { useBackend } from '../backend';
import { PageButton } from '../components/PageButton';
import { Window } from '../layouts';
import { ExaminePanelData } from './ExaminePanelData';
import { FlavorTextPage, ImageGalleryPage } from './ExaminePanelPages';

enum Page {
  FlavorText,
  ImageGallery,
}

export const ExaminePanel = (props) => {
  const { act, data } = useBackend<ExaminePanelData>();
  // OV Edit Start
  const { is_vet, character_name, is_playing, has_song, img_gallery, nsfw_img_gallery, examine_theme, character_ad, start_with_character_ad } = data;
  const [currentPage, setCurrentPage] = useState(Page.FlavorText);
  const [showCharacterAd, setShowCharacterAd] = useState(false);
  const hasAnyGalleryImages = img_gallery.length > 0 || nsfw_img_gallery.length > 0;
  const hasCharacterAd = !!character_ad?.trim();
  const characterAdHTML = useMemo(() => ({
    __html: `<span className='Chat'>${character_ad || ''}</span>`,
  }), [character_ad]);

  useEffect(() => {
    if (showCharacterAd && !hasCharacterAd) {
      setShowCharacterAd(false);
    }
  }, [showCharacterAd, hasCharacterAd]);

  useEffect(() => {
    if (start_with_character_ad && hasCharacterAd) {
      setShowCharacterAd(true);
    }
  }, [start_with_character_ad, hasCharacterAd]);
  // OV Edit End

  let pageContents;

  switch (currentPage) {
    case Page.FlavorText:
      pageContents = <FlavorTextPage />;
      break;
    case Page.ImageGallery:
      pageContents = <ImageGalleryPage />;
      break;
  }

  return (
    <Window title={character_name} width={1000} height={700} theme={examine_theme || undefined} buttons={
      <>
      {!!is_vet && (
        <Button
          color="gold"
          icon="crown"
          tooltip="This player is age-verified!"
          tooltipPosition="bottom-start"
          onClick={() => act('vet_chat')}
        />
      )}
      {/* // OV Edit Start */}
      <Button
      icon="scroll"
      tooltip={hasCharacterAd ? "View character advertisement" : "No character advertisement set"}
      tooltipPosition="bottom-start"
      onClick={() => setShowCharacterAd(true)}
      disabled={!hasCharacterAd}
      style={hasCharacterAd ? {
        boxShadow: '0 0 10px rgba(214, 170, 92, 0.65)',
        borderColor: 'rgba(214, 170, 92, 0.8)',
        backgroundColor: 'rgba(87, 45, 22, 0.85)',
      } : undefined}
      />
      {/* // OV Edit End */}
      <Button
      color="green"
      icon="music"
      tooltip="Music player"
      tooltipPosition="bottom-start"
      onClick={() => act('toggle')}
      disabled={!has_song}
      selected={!is_playing}
      />
      </>}>
      <Window.Content>
        {/* // OV Edit Start */}
        <Box position="relative" height="100%">
          <Stack vertical fill>
            {hasAnyGalleryImages && (
            <Stack style={{ marginBottom: '4px' }}>
              <Stack.Item grow>
                <PageButton
                currentPage={currentPage}
                page={Page.FlavorText}
                setPage={setCurrentPage}
                >
                  Flavor Text
                </PageButton>
              </Stack.Item>
              <Stack.Item grow>
                <PageButton
                currentPage={currentPage}
                page={Page.ImageGallery}
                setPage={setCurrentPage}
                >
                  Image Gallery
                </PageButton>
              </Stack.Item>
            </Stack>
            )}
            {hasAnyGalleryImages && (<Stack.Divider />)}
            <Stack.Item grow position="relative" overflowX="hidden" overflowY="auto">
              {pageContents}
            </Stack.Item>
          </Stack>
          {showCharacterAd && hasCharacterAd && (
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
                title="Character Advertisement"
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
                  <Button icon="times" color="red" onClick={() => setShowCharacterAd(false)}>
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
                  preserveWhitespace
                  dangerouslySetInnerHTML={characterAdHTML}
                />
              </Section>
            </Box>
          )}
        </Box>
        {/* // OV Edit End */}
      </Window.Content>
    </Window>
  );
};
