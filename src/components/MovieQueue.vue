<template>
  <h1 v-if="loading">Queue</h1>
  <h1 v-else-if="error">Queue</h1>
  <h1 v-else-if="queueCount !== null && queueCount !== true && queueCount !== false">Queue ({{ queueCount }})</h1>
  <h1 v-else>Queue ({{ data.length }})</h1>

  <ul v-if="!loading && data && data.length" id="queue">
    <li class="queue-item" v-for="(movie, index) in data" :key="index">
      <div>
        <h2 class="queue-item-header">
          <a :href="'https://imdb.com/title/tt' + movie.imdb.id" class="queue-item-imdb-title"
             target="_blank">{{ movie.imdb.title }}</a>
          ({{ movie.imdb.year }}) {{ movie.imdb.rating }}⭐
        </h2>

        <img :src="movie.imdb.cover.url" v-bind:alt="'cover for ' + movie.imdb.title" class="queue-item-cover-image"
             :width=250 :height="250 * movie.imdb.cover.ratio"/>
      </div>
    </li>
  </ul>

  <p v-if="loading">loading...</p>
  <p v-if="error">
    error loading queue {{ error.message }}
  </p>
</template>

<script>
import {onMounted, ref} from "vue";
import {defineComponent} from "@vue/composition-api";
import pRetry from "p-retry";

const data = ref([]);
const loading = ref(true);
const error = ref(null);
const queueCount = ref(null);

function fetchMovie(id) {
  return fetch('https://api.timhatdiehandandermaus.consulting/movie/' + id, {
    method: 'get',
    'headers': {
      'Content-Type': 'application/json'
    }
  }).then(res => {
    if (!res.ok) {
      const error = new Error(res.statusText);
      error.json = res.json();
      throw error;
    }

    return res.json();
  })
      .catch(err => err)
}

function getCookie(name) {
  const value = `; ${document.cookie}`;
  const parts = value.split(`; ${name}=`);
  if (parts.length === 2) return parts.pop().split(';').shift();
}

function fetchData(initial) {
  loading.value = initial;
  queueCount.value = initial;

  return fetch('https://api.timhatdiehandandermaus.consulting/queue', {
    method: 'get',
    headers: {
      'Content-Type': 'application/json'
    }
  }).then(res => {
    if (!res.ok) {
      const error = new Error(res.statusText);
      error.json = res.json();
      throw error;
    }

    return res.json();
  }).then(json => Promise.all(json.queue.map(async (queueItemResponse, index) => {
    data.value = [];
    if (getCookie("enableBoringQueueCounter") === "true") {
      queueCount.value = json.queue.length;
    }

    pRetry(() => fetchMovie(queueItemResponse.id)
        .then(m => {
          m.index = index;
          data.value.push(m);
          loading.value = false;
        })
        .catch(err => {
          console.error("[ fetchMovie: ", err, " ]");
          return err;
        }), { retries: 3 })
  })))
      .then(() => {
        new Promise(resolve => setTimeout(resolve, 800))
            .then(() => {
              data.value.sort((m1, m2) => m1.index - m2.index);
            })
      })
      .catch(err => {
        error.value = err;
        if (err.json) {
          return err.json.then(json => {
            error.value.message = json.message;
          });
        }
      })
}

export default defineComponent({
  name: "MovieQueue",
  props: {},
  setup() {
    onMounted(() => {
      pRetry(() => fetchData(true), { retries: 3 });
    });

    return {
      data,
      queueCount,
      loading,
      error,
    };
  },
  created() {
    setInterval(() => {
      fetchData(false);

      this.$forceUpdate();
    }, 30000)
  },
});
</script>
