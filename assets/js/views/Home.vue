<template>
  <div class="page-container">
    <md-toolbar class="md-primary">
      <div class="md-toolbar-row">
        <div class="md-toolbar-section-start">
          <span class="md-title">Associations Builder</span>
        </div>
      </div>
    </md-toolbar>

    <div class="box">
      <span class="box-label">Add Themes</span>
      <md-field class="box">
        <label>One Per Line</label>
        <md-textarea v-model="word"></md-textarea>
      </md-field>

      <div class="centered">
        <md-button class="md-primary md-raised" @click="enterClicked()">Submit</md-button>
      </div>
    </div>

    <div class="words box">
      <span class="box-label">Manage Themes</span>

      <div class="box centered">
        <md-button class="md-primary md-raised" @click="download()">Download All</md-button>
        <md-button class="md-primary md-accent md-raised" @click="deleteAll()">Remove All</md-button>
      </div>
      <md-table>
        <md-table-toolbar>
          <h1 class="md-title">Themes</h1>
        </md-table-toolbar>

        <md-table-row>
          <md-table-head>Theme</md-table-head>
          <md-table-head>Related Words</md-table-head>
          <md-table-head>Remove</md-table-head>
          <md-table-head>Download</md-table-head>
        </md-table-row>

        <md-table-row v-for="theme in loading" :key="theme" class="animated fadeIn">
          <md-table-cell>{{theme}}</md-table-cell>
          <md-table-cell col-span="2">Loading ......</md-table-cell>
        </md-table-row>

        <md-table-row v-for="theme in themes" :key="theme.word" class="animated fadeIn">
          <md-table-cell>{{theme.word}}</md-table-cell>
          <md-table-cell>{{theme.words.length}}</md-table-cell>
          <md-table-cell>
            <md-button class="md-accent md-raised" @click="remove(theme.word)">Remove</md-button>
          </md-table-cell>
          <md-table-cell>
            <md-button class="md-primary md-raised" @click="downloadOne(theme)">Download</md-button>
          </md-table-cell>
        </md-table-row>
      </md-table>
    </div>
  </div>
</template>

<script>
import _ from "lodash";
import axios from "axios";
import JSZip from "jszip";
import FileUpload from "./components/FileUpload.vue";
import { saveAs } from "file-saver";

export default {
  components: {
    FileUpload
  },
  data() {
    return {
      word: null,
      themes: [],
      loading: []
    };
  },
  methods: {
    enterClicked() {
      this.word.split("\n").forEach(this.loadTheme);
      this.word = null;
    },
    loadTheme(theme) {
      let self = this;
      this.loading.push(theme);
      axios
        .post("/api/themes", { theme: theme })
        .then(function(response) {
          self.themes.unshift({ word: theme, words: response.data });
          self.loading = self.loading.filter(l => l != theme);
        })
        .catch(function(error) {
          console.log(error);
        });
    },
    addMultipule(files) {
      return Promise.all(files.map(file => this.onSaveFile(file)));
    },
    onSaveFile(file) {
      let self = this;
      let formData = new FormData();
      formData.append("file", file);
      return axios
        .post(`/api/themes/multi`, formData, {
          headers: {
            "Content-Type": "multipart/form-data"
          }
        })
        .then(r => {
          self.getThemes();
        });
    },
    remove(theme) {
      let self = this;
      axios
        .delete(`/api/themes/${theme}`)
        .then(function(response) {
          self.themes = self.themes.filter(t => t.word != theme);
        })
        .catch(function(error) {
          console.log(error);
        });
    },
    fileContent(theme) {
      return [theme.word]
        .concat(theme.words.map(t => t.toLowerCase()))
        .join("\r\n");
    },
    download() {
      let zip = new JSZip();
      this.themes.forEach(t => zip.file(`${t.word}.txt`, this.fileContent(t)));
      zip.generateAsync({ type: "blob" }).then(function(content) {
        saveAs(content, "themes.zip");
      });
    },
    deleteAll() {
      let self = this;

      axios.post("/api/themes/clear").then(function(response) {
        self.getThemes();
      });
    },
    downloadOne(theme) {
      var blob = new Blob([this.fileContent(theme)], {
        type: "text/plain;charset=utf-8"
      });
      saveAs(blob, `${theme.word}.txt`);
    },
    getThemes() {
      let self = this;
      axios
        .get("/api/themes")
        .then(function(response) {
          self.themes = Object.keys(response.data).map(r => {
            return { word: r, words: response.data[r] };
          });
        })
        .catch(function(error) {
          console.log(error);
        });
    }
  },

  mounted() {
    this.getThemes();
  }
};
</script>
