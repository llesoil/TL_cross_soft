#!/bin/sh

numb='3048'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 0.5 --ipratio 1.4 --pbratio 1.3 --psy-rd 3.8 --qblur 0.4 --qcomp 0.9 --vbv-init 0.0 --aq-mode 1 --b-adapt 1 --bframes 14 --crf 40 --keyint 280 --lookahead-threads 4 --min-keyint 22 --qp 10 --qpstep 4 --qpmin 3 --qpmax 68 --rc-lookahead 38 --ref 3 --vbv-bufsize 2000 --deblock -2:-2 --me hex --overscan show --preset ultrafast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,0.5,1.4,1.3,3.8,0.4,0.9,0.0,1,1,14,40,280,4,22,10,4,3,68,38,3,2000,-2:-2,hex,show,ultrafast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"