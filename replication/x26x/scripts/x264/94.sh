#!/bin/sh

numb='95'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 1.5 --ipratio 1.0 --pbratio 1.0 --psy-rd 0.8 --qblur 0.3 --qcomp 0.9 --vbv-init 0.3 --aq-mode 0 --b-adapt 0 --bframes 10 --crf 25 --keyint 270 --lookahead-threads 3 --min-keyint 28 --qp 50 --qpstep 4 --qpmin 3 --qpmax 62 --rc-lookahead 28 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan crop --preset veryslow --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,1.5,1.0,1.0,0.8,0.3,0.9,0.3,0,0,10,25,270,3,28,50,4,3,62,28,6,2000,-1:-1,hex,crop,veryslow,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"