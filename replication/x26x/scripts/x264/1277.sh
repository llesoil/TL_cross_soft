#!/bin/sh

numb='1278'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 4.2 --qblur 0.5 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 1 --bframes 12 --crf 15 --keyint 220 --lookahead-threads 1 --min-keyint 27 --qp 40 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 38 --ref 5 --vbv-bufsize 2000 --deblock 1:1 --me hex --overscan show --preset slow --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.2,1.1,4.2,0.5,0.6,0.4,2,1,12,15,220,1,27,40,4,0,62,38,5,2000,1:1,hex,show,slow,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"