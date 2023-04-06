
import DefaultTeaserBody from '@kitconcept/volto-blocks-grid/components/Teaser/DefaultBody';

import calendarSVG from '@plone/volto/icons/calendar.svg';
import heroSVG from '@plone/volto/icons/hero.svg';
import images from '@plone/volto/icons/images.svg';
import listBulletSVG from '@plone/volto/icons/list-bullet.svg';
import sliderSVG from '@plone/volto/icons/slider.svg';
import zoomSVG from '@plone/volto/icons/zoom.svg';


const applyConfig = (config) => {
  config.settings = {
    ...config.settings,
    isMultilingual: false,
    supportedLanguages: ['en'],
    defaultLanguage: 'en',
    matomoSiteId: '11',
    matomoUrlBase: 'https://stats.plone.org/',
    socialNetworks: [
      {
        id: 'twitter',
        url: 'https://twitter.com/plone',
      },
      {
        id: 'facebook',
        url: 'https://www.facebook.com/Plone',
      },
      {
        id: 'youtube',
        url: 'http://youtube.com/c/PloneCMS',
      },
    ],
  };

  config.blocks.blocksConfig.teaser.variations = [
    {
      id: 'default',
      isDefault: true,
      title: 'Default',
      template: DefaultTeaserBody,
    },
  ];

  return config;
};

export default applyConfig;
