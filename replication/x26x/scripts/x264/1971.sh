#!/bin/sh

numb='1972'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.3 --pbratio 1.0 --psy-rd 1.0 --qblur 0.5 --qcomp 0.7 --vbv-init 0.2 --aq-mode 2 --b-adapt 1 --bframes 8 --crf 0 --keyint 220 --lookahead-threads 3 --min-keyint 29 --qp 20 --qpstep 5 --qpmin 4 --qpmax 66 --rc-lookahead 28 --ref 2 --vbv-bufsize 2000 --deblock -1:-1 --me hex --overscan show --preset medium --scenecut 10 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.3,1.0,1.0,0.5,0.7,0.2,2,1,8,0,220,3,29,20,5,4,66,28,2,2000,-1:-1,hex,show,medium,10,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"