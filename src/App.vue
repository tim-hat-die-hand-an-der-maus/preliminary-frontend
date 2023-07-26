<template>
  <p id="commitsha">__commit_sha__</p>

  <MovieQueue/>
</template>

<script>
import MovieQueue from './components/MovieQueue.vue'

export default {
  name: 'App',
  components: {
    MovieQueue
  }
}
</script>

<style>
body {
  background-color: #225522;
  color: #9e9a93;
}

a {
  color: #bebaf3;
}

#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  /* color: #2c3e50; */
  margin-top: 60px;
}

#commitsha {
  display: none;
}

.queue-item {
  list-style: none;
  flex: 1;
  width: 250px;
  height: 500px;
}

#queue {
  display: flex;
  flex-wrap: wrap;
}

.queue-item-cover-image {
  max-height: 400px;
}

.queue-item-header {
  height: 80px;
}
</style>
