<template>
  <h1>Queue</h1>

  <ul v-if="!loading && data && data.length" id="queue">
    <li class="queue-item" v-for="(movie, index) in data" :key="index">
      <div>
        <h2>
          <a :href="'https://imdb.com/title/' + movie.imdb.id" class="queue-item-imdb-title">{{ movie.imdb.title }}</a>
          ({{ movie.imdb.year }}) {{ movie.imdb.rating }}⭐
        </h2>

        <img :src="movie.imdb.coverUrl" v-bind:alt="'cover for' + movie.imdb.title" />
      </div>
    </li>
  </ul>

  <p v-if="loading">loading...</p>
  <p v-if="error">
    <!-- TODO -->
    error loading queue {{ error.message }}
  </p>
</template>

<script>
import { onMounted, ref } from "vue";
import { defineComponent } from "@vue/composition-api";

export default defineComponent({
  name: "Queue",
  props: {},
  setup() {
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

        return res.json()
      }).then(json => {
        return json;
      })
      .catch(err => err)
    }

    function fetchData() {
        loading.value = true;

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
        }).then(json => {
            let value = Promise.all(json.queue.map(async queueItemResponse => {
              let fm = await fetchMovie(queueItemResponse.id)
                .then(json => {
                  var res = json;

                  return res;
                })
                .catch(err => {
                  console.error("error: ", err);
                  return err;
                })
                .then(json => json);

                return fm;
            }));

            return value;
        })
        .then(json => {
          data.value = json;
          return json;
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

    onMounted(() => {
      fetchData();
    });

    return {
      data,
      loading,
      error,
    };
  },
});
</script>
