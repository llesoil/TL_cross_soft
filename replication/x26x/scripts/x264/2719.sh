#!/bin/sh

numb='2720'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 2.5 --ipratio 1.1 --pbratio 1.0 --psy-rd 1.4 --qblur 0.3 --qcomp 0.9 --vbv-init 0.1 --aq-mode 2 --b-adapt 0 --bframes 14 --crf 35 --keyint 210 --lookahead-threads 1 --min-keyint 21 --qp 40 --qpstep 5 --qpmin 2 --qpmax 67 --rc-lookahead 38 --ref 1 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset medium --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,2.5,1.1,1.0,1.4,0.3,0.9,0.1,2,0,14,35,210,1,21,40,5,2,67,38,1,2000,-1:-1,umh,show,medium,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"