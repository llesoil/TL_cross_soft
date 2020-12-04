#!/bin/sh

numb='2330'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --slow-firstpass --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.3 --psy-rd 2.4 --qblur 0.5 --qcomp 0.6 --vbv-init 0.0 --aq-mode 1 --b-adapt 2 --bframes 2 --crf 15 --keyint 210 --lookahead-threads 0 --min-keyint 30 --qp 20 --qpstep 3 --qpmin 4 --qpmax 68 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset fast --scenecut 0 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.5,1.2,1.3,2.4,0.5,0.6,0.0,1,2,2,15,210,0,30,20,3,4,68,38,5,2000,-1:-1,umh,show,fast,0,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"