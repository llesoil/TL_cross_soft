#!/bin/sh

numb='1038'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-asm --weightb --aq-strength 0.0 --ipratio 1.4 --pbratio 1.2 --psy-rd 0.4 --qblur 0.3 --qcomp 0.8 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 40 --keyint 210 --lookahead-threads 0 --min-keyint 26 --qp 40 --qpstep 3 --qpmin 0 --qpmax 64 --rc-lookahead 18 --ref 3 --vbv-bufsize 1000 --deblock -2:-2 --me umh --overscan show --preset slow --scenecut 30 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,--no-asm,None,--weightb,0.0,1.4,1.2,0.4,0.3,0.8,0.2,2,1,12,40,210,0,26,40,3,0,64,18,3,1000,-2:-2,umh,show,slow,30,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"