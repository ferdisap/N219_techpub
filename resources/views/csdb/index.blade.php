@extends('html_head',[
  'title' => 'CSDB Index'
])

@section('body')
  <header>
    @include('navbar')
  </header>

  @include('project.components.info')

  <div class="d-flex">
    @include ('project.aside')
  
    <section>
      <div>
        List of model ident codes
        <ol>
          <li><a href="/csdb?mic=male">MALE</a></li>
          <li><a href="/csdb?mic=n219">N219</a></li>
          <li><a href="/csdb?mic=entity">entity</a></li>
        </ol>
      </div>
      @if(isset($listsobj))
      <table>
        
        <thead class="border-bottom">
          <tr>
            <th>Filename</th>
            <th>Status</th>
            <th>Action</th>
            <th>Description</th>
            <th>Initiator</th>
          </tr>
        </thead>
        <tbody>
          @foreach($listsobj as $obj)
            @php
            $filename = $obj->filename;
            $status = $obj->status;
            $description = $obj->description;
            @endphp
            <tr>
              <td><a href="/route/get_update_csdb_object?filename={{ $filename }}">{{ $filename }}</a></td>
              <td><a href="?status={{ $status }}">{{ $status }}</a></td>

              <td class="d-flex">
                {{-- <button><a href="/csdb/object/update?filename={{ $filename }}">update</a></button> --}}
                <button><a href="/route/get_update_csdb_object?filename={{ $filename }}">update</a></button>
                <button><a href="{{ route('get_delete_csdb_object') }}?filename={{ $filename }}">delete</a></button>
                <button><a href="{{ route('get_restore_csdb_object') }}?filename={{ $filename }}">restore</a></button>
                <form action="{{ route('post_delete_csdb_object') }}" method="post">
                  @csrf
                  <input type="hidden" name="filename" value="{{ $filename }}">
                  <button type="submit" class="underline">hard delete</button>
                </form>
              </td>

              <td>{{ $description }}</td>
              <td><a href="?initiator={{ $obj->initiator->email }}">{{ $obj->initiator->email }}</a></td>
            </tr>
          @endforeach
        </tbody>
      </table>
      @endif
    </section>
  </div>
@endsection