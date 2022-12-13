import { Component, HostListener, Output, ViewChild } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { SocketService } from 'src/services/socket.service';
import { ToastrService } from 'ngx-toastr';
import { SoundService } from 'src/services/sound.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {


  constructor(
    private http: HttpClient,
    private srv: SocketService,
    private toastr: ToastrService,
    private soundService: SoundService
  ) {
  }

  ngOnInit(){
  }


  @HostListener('window:message', ['$event'])
  onMessage(event: MessageEvent) {
    switch (event.data.type) {
      case "success":
        this.toastr.success(event.data.text, event.data.title, {
          progressBar: true,
          timeOut: 7000
        });
        break;
      case "error":
        this.toastr.error(event.data.text, event.data.title, {
          progressBar: true,
          timeOut: 7000
        });
        break;
      case "info":
        this.toastr.info(event.data.text, event.data.title, {
          progressBar: true,
          timeOut: 7000
        });
        break;
      case "warning":
        this.toastr.warning(event.data.text, event.data.title, {
          progressBar: true,
          timeOut: 7000
        });
        break;
      case "sound":
        this.soundService.playSound(event.data.sound)
        break;
      default:
        break;
    }
    
  }


}

