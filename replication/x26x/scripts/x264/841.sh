#!/bin/sh

numb='842'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 1.0 --ipratio 1.0 --pbratio 1.3 --psy-rd 2.4 --qblur 0.6 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 2 --bframes 10 --crf 40 --keyint 260 --lookahead-threads 0 --min-keyint 25 --qp 50 --qpstep 5 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,1.0,1.0,1.3,2.4,0.6,0.9,0.1,2,2,10,40,260,0,25,50,5,4,69,28,3,2000,-2:-2,hex,show,medium,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"