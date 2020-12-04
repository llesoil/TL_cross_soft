#!/bin/sh

numb='1244'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 2.0 --qblur 0.3 --qcomp 0.6 --vbv-init 0.4 --aq-mode 2 --b-adapt 0 --bframes 12 --crf 30 --keyint 210 --lookahead-threads 4 --min-keyint 27 --qp 40 --qpstep 3 --qpmin 0 --qpmax 63 --rc-lookahead 38 --ref 6 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset slower --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,1.5,1.4,1.3,2.0,0.3,0.6,0.4,2,0,12,30,210,4,27,40,3,0,63,38,6,1000,-1:-1,hex,show,slower,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"