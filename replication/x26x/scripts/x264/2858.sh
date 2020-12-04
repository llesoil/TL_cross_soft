#!/bin/sh

numb='2859'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --constrained-intra --no-weightb --aq-strength 3.0 --ipratio 1.1 --pbratio 1.2 --psy-rd 2.4 --qblur 0.2 --qcomp 0.9 --vbv-init 0.8 --aq-mode 1 --b-adapt 0 --bframes 10 --crf 30 --keyint 290 --lookahead-threads 2 --min-keyint 26 --qp 20 --qpstep 5 --qpmin 2 --qpmax 68 --rc-lookahead 28 --ref 1 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan crop --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,None,--constrained-intra,None,None,None,--no-weightb,3.0,1.1,1.2,2.4,0.2,0.9,0.8,1,0,10,30,290,2,26,20,5,2,68,28,1,2000,-2:-2,hex,crop,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"