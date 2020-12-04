#!/bin/sh

numb='462'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 2.4 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 0 --bframes 2 --crf 30 --keyint 260 --lookahead-threads 4 --min-keyint 23 --qp 40 --qpstep 3 --qpmin 2 --qpmax 63 --rc-lookahead 28 --ref 1 --vbv-bufsize 1000 --deblock -2:-2 --me dia --overscan show --preset slower --scenecut 40 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.0,1.6,1.0,2.4,0.5,0.8,0.4,1,0,2,30,260,4,23,40,3,2,63,28,1,1000,-2:-2,dia,show,slower,40,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"