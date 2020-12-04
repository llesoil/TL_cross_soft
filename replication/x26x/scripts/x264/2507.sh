#!/bin/sh

numb='2508'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --weightb --aq-strength 0.0 --ipratio 1.5 --pbratio 1.2 --psy-rd 2.4 --qblur 0.4 --qcomp 0.8 --vbv-init 0.8 --aq-mode 2 --b-adapt 0 --bframes 4 --crf 0 --keyint 210 --lookahead-threads 1 --min-keyint 26 --qp 40 --qpstep 4 --qpmin 0 --qpmax 62 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset ultrafast --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--weightb,0.0,1.5,1.2,2.4,0.4,0.8,0.8,2,0,4,0,210,1,26,40,4,0,62,28,2,2000,-2:-2,hex,crop,ultrafast,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"