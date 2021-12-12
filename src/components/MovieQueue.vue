<template>
  <h1>Queue</h1>

  <ul v-if="!loading && data && data.length" id="queue">
    <li class="queue-item" v-for="(movie, index) in data" :key="index">
      <div>
        <h2 class="queue-item-header">
          <a :href="'https://imdb.com/title/tt' + movie.imdb.id" class="queue-item-imdb-title" target="_blank">{{ movie.imdb.title }}</a>
          ({{ movie.imdb.year }}) {{ movie.imdb.rating }}⭐
        </h2>

        <img :src="movie.imdb.coverUrl" v-bind:alt="'cover for ' + movie.imdb.title" class="queue-item-cover-image" />
      </div>
    </li>
  </ul>

  <p v-if="loading">loading...</p>
  <p v-if="error">
    error loading queue {{ error.message }}
  </p>
</template>

<script>
import { onMounted, ref } from "vue";
import { defineComponent } from "@vue/composition-api";

const data = ref(null);
const loading = ref(true);
const error = ref(null);

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

function fetchData(initial) {
    loading.value = initial;

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
    }).then(json => Promise.all(json.queue.map(async queueItemResponse =>
          await fetchMovie(queueItemResponse.id)
            .catch(err => {
              console.error("[ fetchMovie: ", err, " ]");
              return err;
            }))))
    .then(json => {
      data.value = json;
    })
    .catch(err => {
        error.value = err;
        if (err.json) {
            return err.json.then(json => {
                error.value.message = json.message;
            });
        }
    })
    .then(() => {
        loading.value = false;
    })
}

export default defineComponent({
  name: "MovieQueue",
  props: {},
  setup() {
    onMounted(() => {
      fetchData(true);
    });

    return {
      data,
      loading,
      error,
    };
  },
  created() {
    setInterval(() => {
      console.log("update");
      fetchData(false);

      this.$forceUpdate();
    }, 30000)
  },
});
</script>
