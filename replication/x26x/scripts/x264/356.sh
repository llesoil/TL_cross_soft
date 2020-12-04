#!/bin/sh

numb='357'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --weightb --aq-strength 0.5 --ipratio 1.5 --pbratio 1.1 --psy-rd 3.2 --qblur 0.5 --qcomp 0.9 --vbv-init 0.4 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 20 --keyint 290 --lookahead-threads 1 --min-keyint 22 --qp 40 --qpstep 4 --qpmin 1 --qpmax 66 --rc-lookahead 18 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan show --preset faster --scenecut 0 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--weightb,0.5,1.5,1.1,3.2,0.5,0.9,0.4,1,1,14,20,290,1,22,40,4,1,66,18,4,2000,-2:-2,umh,show,faster,0,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"