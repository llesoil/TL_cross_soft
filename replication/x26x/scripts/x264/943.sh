#!/bin/sh

numb='944'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.4 --psy-rd 1.0 --qblur 0.5 --qcomp 0.8 --vbv-init 0.3 --aq-mode 1 --b-adapt 0 --bframes 6 --crf 45 --keyint 270 --lookahead-threads 3 --min-keyint 29 --qp 0 --qpstep 4 --qpmin 4 --qpmax 64 --rc-lookahead 28 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset medium --scenecut 10 --tune grain --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.4,1.0,0.5,0.8,0.3,1,0,6,45,270,3,29,0,4,4,64,28,4,2000,-2:-2,hex,show,medium,10,grain,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"