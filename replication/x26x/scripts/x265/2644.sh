#!/bin/sh

numb='2645'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --slow-firstpass --no-weightb --aq-strength 2.0 --ipratio 1.3 --pbratio 1.2 --psy-rd 4.2 --qblur 0.2 --qcomp 0.9 --vbv-init 0.6 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 25 --keyint 240 --lookahead-threads 3 --min-keyint 21 --qp 20 --qpstep 3 --qpmin 0 --qpmax 69 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,--slow-firstpass,--no-weightb,2.0,1.3,1.2,4.2,0.2,0.9,0.6,2,1,12,25,240,3,21,20,3,0,69,38,6,1000,1:1,umh,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"