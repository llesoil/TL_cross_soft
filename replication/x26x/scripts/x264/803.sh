#!/bin/sh

numb='804'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --weightb --aq-strength 1.5 --ipratio 1.1 --pbratio 1.1 --psy-rd 2.4 --qblur 0.4 --qcomp 0.9 --vbv-init 0.7 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 30 --keyint 250 --lookahead-threads 0 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 2 --qpmax 69 --rc-lookahead 28 --ref 6 --vbv-bufsize 1000 --deblock 1:1 --me dia --overscan show --preset slow --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,None,None,None,None,--weightb,1.5,1.1,1.1,2.4,0.4,0.9,0.7,3,0,14,30,250,0,28,50,4,2,69,28,6,1000,1:1,dia,show,slow,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"