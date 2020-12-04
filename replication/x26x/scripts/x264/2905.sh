#!/bin/sh

numb='2906'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.3 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.0 --aq-mode 0 --b-adapt 2 --bframes 2 --crf 45 --keyint 230 --lookahead-threads 3 --min-keyint 22 --qp 0 --qpstep 5 --qpmin 1 --qpmax 60 --rc-lookahead 48 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset slow --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.3,1.4,1.0,0.5,0.7,0.0,0,2,2,45,230,3,22,0,5,1,60,48,6,1000,-1:-1,umh,show,slow,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"