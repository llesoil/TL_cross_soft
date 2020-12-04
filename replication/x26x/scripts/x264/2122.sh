#!/bin/sh

numb='2123'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.6 --pbratio 1.3 --psy-rd 4.2 --qblur 0.3 --qcomp 0.9 --vbv-init 0.8 --aq-mode 0 --b-adapt 1 --bframes 10 --crf 15 --keyint 280 --lookahead-threads 1 --min-keyint 23 --qp 10 --qpstep 5 --qpmin 2 --qpmax 62 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset medium --scenecut 40 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,2.5,1.6,1.3,4.2,0.3,0.9,0.8,0,1,10,15,280,1,23,10,5,2,62,28,1,2000,-2:-2,umh,show,medium,40,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"