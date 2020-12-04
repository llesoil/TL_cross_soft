#!/bin/sh

numb='2208'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x265  --aud --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 4.4 --qblur 0.3 --qcomp 0.7 --vbv-init 0.6 --aq-mode 0 --b-adapt 0 --bframes 6 --crf 0 --keyint 270 --lookahead-threads 4 --min-keyint 25 --qp 0 --qpstep 5 --qpmin 2 --qpmax 66 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock 1:1 --me dia --overscan show --preset veryslow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)(//; s/encoded// ; s/fps)// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--no-weightb,3.0,1.1,1.2,4.4,0.3,0.7,0.6,0,0,6,0,270,4,25,0,5,2,66,28,6,2000,1:1,dia,show,veryslow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"