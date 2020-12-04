#!/bin/sh

numb='2681'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 5.0 --qblur 0.5 --qcomp 0.6 --vbv-init 0.2 --aq-mode 0 --b-adapt 0 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 3 --min-keyint 26 --qp 10 --qpstep 4 --qpmin 0 --qpmax 60 --rc-lookahead 28 --ref 3 --vbv-bufsize 1000 --deblock -1:-1 --me umh --overscan show --preset ultrafast --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--weightb,0.5,1.2,1.1,5.0,0.5,0.6,0.2,0,0,2,15,210,3,26,10,4,0,60,28,3,1000,-1:-1,umh,show,ultrafast,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"