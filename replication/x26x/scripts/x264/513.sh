#!/bin/sh

numb='514'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.0 --ipratio 1.6 --pbratio 1.0 --psy-rd 4.2 --qblur 0.5 --qcomp 0.7 --vbv-init 0.1 --aq-mode 3 --b-adapt 0 --bframes 14 --crf 45 --keyint 300 --lookahead-threads 4 --min-keyint 24 --qp 0 --qpstep 3 --qpmin 3 --qpmax 60 --rc-lookahead 28 --ref 5 --vbv-bufsize 1000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.0,1.6,1.0,4.2,0.5,0.7,0.1,3,0,14,45,300,4,24,0,3,3,60,28,5,1000,-1:-1,hex,show,medium,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"