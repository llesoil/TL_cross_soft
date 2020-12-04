#!/bin/sh

numb='744'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-asm --weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 2.0 --qblur 0.2 --qcomp 0.6 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 4 --crf 50 --keyint 200 --lookahead-threads 4 --min-keyint 28 --qp 10 --qpstep 4 --qpmin 3 --qpmax 63 --rc-lookahead 48 --ref 4 --vbv-bufsize 2000 --deblock -2:-2 --me umh --overscan crop --preset superfast --scenecut 10 --tune animation --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,--no-asm,None,--weightb,1.5,1.3,1.0,2.0,0.2,0.6,0.2,2,1,4,50,200,4,28,10,4,3,63,48,4,2000,-2:-2,umh,crop,superfast,10,animation,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"