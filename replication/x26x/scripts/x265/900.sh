#!/bin/sh

numb='901'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --no-weightb --aq-strength 2.0 --ipratio 1.5 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.7 --vbv-init 0.9 --aq-mode 1 --b-adapt 0 --bframes 14 --crf 15 --keyint 240 --lookahead-threads 1 --min-keyint 25 --qp 50 --qpstep 3 --qpmin 1 --qpmax 63 --rc-lookahead 18 --ref 2 --vbv-bufsize 2000 --deblock 1:1 --me umh --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--no-weightb,2.0,1.5,1.3,2.0,0.3,0.7,0.9,1,0,14,15,240,1,25,50,3,1,63,18,2,2000,1:1,umh,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"