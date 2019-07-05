<template>
<div class="dropbox">
    <input type="file" multiple 
            @change="filesChanged($event.target.files)"
            class="input-file">
    
        <p v-if="saving">
            Uploading {{ fileCount }} files...
        </p>
        <p v-else>
            Drag your file(s) here to begin<br> <strong>or click to browse</strong>
        </p>
</div>
</template>

<script>

let fileListToArray= function (fileList) {
  return Array.from(fileList);
}

export default {
    name: 'FileUpload',
    props: {
        uploadFileFunction: Function
    },
    data() {
      return {
        saving: false, 
        filesCount: 0,
      }
    },
    methods: {
      filesChanged(fileList) {
        let fileListArray = fileListToArray(fileList);
        this.fileCount = fileListArray.length
        this.saving = true;
        this.uploadFileFunction(fileListArray).then(function(){
          this.saving = false;
        }.bind(this))
    }
  }
}
</script>


