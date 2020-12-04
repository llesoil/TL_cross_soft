#!/bin/sh

numb='1567'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 0.0 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.4 --qblur 0.2 --qcomp 0.6 --vbv-init 0.5 --aq-mode 1 --b-adapt 1 --bframes 4 --crf 25 --keyint 210 --lookahead-threads 4 --min-keyint 22 --qp 30 --qpstep 5 --qpmin 0 --qpmax 65 --rc-lookahead 18 --ref 5 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan crop --preset placebo --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,0.0,1.2,1.1,4.4,0.2,0.6,0.5,1,1,4,25,210,4,22,30,5,0,65,18,5,1000,-2:-2,umh,crop,placebo,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"