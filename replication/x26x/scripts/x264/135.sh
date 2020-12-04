#!/bin/sh

numb='136'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --no-weightb --aq-strength 1.5 --ipratio 1.2 --pbratio 1.1 --psy-rd 1.6 --qblur 0.4 --qcomp 0.8 --vbv-init 0.4 --aq-mode 0 --b-adapt 0 --bframes 8 --crf 30 --keyint 260 --lookahead-threads 0 --min-keyint 29 --qp 10 --qpstep 3 --qpmin 4 --qpmax 69 --rc-lookahead 28 --ref 2 --vbv-bufsize 1000 --deblock -1:-1 --me dia --overscan crop --preset superfast --scenecut 40 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,None,--no-weightb,1.5,1.2,1.1,1.6,0.4,0.8,0.4,0,0,8,30,260,0,29,10,3,4,69,28,2,1000,-1:-1,dia,crop,superfast,40,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"