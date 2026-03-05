// @ts-check
import { defineConfig } from 'astro/config';
import starlight from '@astrojs/starlight';

// https://astro.build/config
export default defineConfig({
  site: 'https://purus.work',
  outDir: '../docs',
  integrations: [
    starlight({
      title: 'Purus',
      logo: {
        src: './src/assets/icon.png',
      },
      head: [
        {
          tag: 'meta',
          attrs: { property: 'og:image', content: 'https://purus.work/img/banner.png' },
        },
        {
          tag: 'meta',
          attrs: { name: 'twitter:card', content: 'summary_large_image' },
        },
        {
          tag: 'meta',
          attrs: { name: 'twitter:image', content: 'https://purus.work/img/banner.png' },
        },
      ],
      social: [
        { icon: 'github', label: 'GitHub', href: 'https://github.com/otoneko1102/purus' },
      ],
      editLink: {
        baseUrl: 'https://github.com/otoneko1102/purus/edit/main/pages/',
      },
      defaultLocale: 'root',
      locales: {
        root: { label: 'English', lang: 'en' },
        ja: { label: '日本語', lang: 'ja' },
      },
      sidebar: [
        {
          label: 'Getting Started',
          translations: { ja: 'はじめに' },
          autogenerate: { directory: 'getting-started' },
        },
        {
          label: 'Language Reference',
          translations: { ja: '言語リファレンス' },
          autogenerate: { directory: 'reference' },
        },
        {
          label: 'Tools',
          translations: { ja: 'ツール' },
          autogenerate: { directory: 'tools' },
        },
      ],
    }),
  ],
});
