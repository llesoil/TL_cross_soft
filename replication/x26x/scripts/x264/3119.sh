#!/bin/sh

numb='3120'
logfilename="./logs/$numb.log"
inputlocation="$1"
outputlocation="test.mp4"
inputconf="$2"

{ time x264  --aud --constrained-intra --slow-firstpass --no-weightb --aq-strength 1.0 --ipratio 1.1 --pbratio 1.3 --psy-rd 2.6 --qblur 0.5 --qcomp 0.8 --vbv-init 0.4 --aq-mode 1 --b-adapt 2 --bframes 16 --crf 10 --keyint 210 --lookahead-threads 4 --min-keyint 26 --qp 0 --qpstep 5 --qpmin 1 --qpmax 62 --rc-lookahead 48 --ref 6 --vbv-bufsize 2000 --deblock -1:-1 --me umh --overscan show --preset slower --scenecut 30 --tune psnr --output $outputlocation $inputconf $inputlocation ; } 2> $logfilename
# extract output video size
size=`ls -lrt $outputlocation | awk '{print $5}'`
# analyze log to extract relevant timing information and CPU usage
time=`grep "user" $logfilename | sed 's/,/./; s/elapsed/,/; s/system/,/; s/user/,/; s/ //g' | cut -d "%" -f 1`
# analyze log to extract fps and kbs
persec=`grep "encoded" $logfilename | sed 's/encoded\(.*\)frames// ; s/fps// ; s//,/; s/ //g' | cut -d "k" -f 1`
# clean
#rm $outputlocation

csvLine="$numb,--aud,--constrained-intra,None,None,--slow-firstpass,--no-weightb,1.0,1.1,1.3,2.6,0.5,0.8,0.4,1,2,16,10,210,4,26,0,5,1,62,48,6,2000,-1:-1,umh,show,slower,30,psnr,"
csvLine="$csvLine$size,$time,$persec"
echo "$csvLine"